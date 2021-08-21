# Terraform AWS ECS Service

This is dependent on `Terraform AWS ECS Infrastructure` which should have been built already.

It imports the state from the infrastructure in order to know where to deploy this service.

## Whats Missing

This is just an example and you'll need to add some stuff for production.

* Add HTTPS listening, check out the `aws_alb_listener`
* Add Route53, the ALB DNS is hard to remember :)

 
