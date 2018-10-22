
/* *****To do SSH from bastion**** : Allow inbound traffic from bastion server IP or local workstation external IP to the Kubernetes. 
   Replace A.B.C.D below with your real IP. Services like icanhazip.com can help you find this.
*/

resource "aws_security_group_rule" "ingress-self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.nodes-security-group.id}"
  source_security_group_id = "${aws_security_group.nodes-security-group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.nodes-security-group.id}"
  source_security_group_id = "${aws_security_group.master-security-group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

/* Allow inbound traffic from other like bastion server IP/local workstation/other VPC, external IP etc., to the Kubernetes cluster
   Replace W.X.Y.Z below with your IP/CIDR block
*/
resource "aws_security_group_rule" "ingress-others-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  #cidr_blocks       = ["W.X.Y.Z/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.master-security-group.id}"
  to_port           = 443
  type              = "ingress"
}

/* 
   ==============================================
   || Worker Node Access to EKS Master Cluster ||
	 ==============================================
   Now that we have a way to know where traffic from the worker nodes is coming from, we can allow the worker nodes networking access to the EKS master cluster.
*/
resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.master-security-group.id}"
  source_security_group_id = "${aws_security_group.nodes-security-group.id}"
  to_port                  = 443
  type                     = "ingress"
}

