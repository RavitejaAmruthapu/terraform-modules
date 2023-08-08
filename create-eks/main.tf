# Create an IAM role
resource "aws_iam_role" "eks_cluster_role" {
  name = var.cluster_role_name

  assume_role_policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": [
                        "eks.amazonaws.com"
                    ]
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "eks_cluster_role_policy_attachment" {
    name        = "EKS_Cluster_Policy_Attachment"
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    roles       = [aws_iam_role.eks_cluster_role.id]
}

# Create an IAM role
resource "aws_iam_role" "eks_node_role" {
  name = var.node_role_name

  assume_role_policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
    })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "eks_node_role_policy_attachment" {
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ])

    name        = "EKS_Node_Policy_Attachment"
    policy_arn  = each.value
    roles       = [aws_iam_role.eks_node_role.id]
}

data "aws_vpc" "cluster_vpc" {
    default = true
}

data "aws_subnet_ids" "cluster_subnet_ids" {
    vpc_id = data.aws_vpc.cluster_vpc.id
}

resource "aws_eks_cluster" "cluster" {
    name     = var.cluster_name
    role_arn = aws_iam_role.eks_cluster_role.arn
    version  = var.cluster_version
    vpc_config {
        subnet_ids = data.aws_subnet_ids.cluster_subnet_ids.ids
        endpoint_public_access = true
    }

    depends_on = [
        aws_iam_policy_attachment.eks_cluster_role_policy_attachment
    ]
}

resource "aws_eks_node_group" "eks_cluster_nodegroup_ondemand" {
    cluster_name    = aws_eks_cluster.cluster.name
    node_group_name = var.node-group-name
    node_role_arn   = aws_iam_role.eks_node_role.arn
    subnet_ids      = data.aws_subnet_ids.cluster_subnet_ids.ids

    labels = {
        type_of_nodegroup = "on_demand_untainted"
    }

    scaling_config {
        desired_size = 2
        max_size     = 2
        min_size     = 2
    }

    depends_on = [
        aws_iam_policy_attachment.eks_node_role_policy_attachment,
        aws_eks_addon.addons
    ]
}


resource "aws_eks_addon" "addons" {
    for_each          = { for addon in var.addons : addon.name => addon }
    cluster_name      = aws_eks_cluster.cluster.id
    addon_name        = each.value.name
    //addon_version     = each.value.version
    //resolve_conflicts = "OVERWRITE"

    depends_on = [
        aws_eks_cluster.cluster
    ]
}