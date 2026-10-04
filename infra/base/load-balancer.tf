module "aws_lb_controller_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.9"

  name = "aws-load-balancer-controller"

  attach_aws_lb_controller_policy = true

  associations = {
    controller = {
      cluster_name    = "${var.project_name}-clr"
      namespace       = "kube-system"
      service_account = "aws-load-balancer-controller"
    }
  }

  tags = {
    Project   = "zero-trust-preview-engine"
    Component = "aws-load-balancer-controller"
  }
}


resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  # Helm chart version
  version = "1.14.0"

  set = [
    {
      name  = "clusterName"
      value = "${var.project_name}-clr"
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }
  ]

  depends_on = [
    module.aws_lb_controller_pod_identity
  ]
}
