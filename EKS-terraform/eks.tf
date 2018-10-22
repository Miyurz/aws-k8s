resource "aws_eks_cluster" "eks-cluster" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.master-iam-role.arn}"
  version         = "${var.k8s-master-version}"

  vpc_config {
    security_group_ids = ["${aws_security_group.master-security-group.id}"]
    subnet_ids         = ["${aws_subnet.subnet-1.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy",
  ]
}

