output "alb_dns_name" {
    value = aws_lb.this.dns_name
}

output "alb_zone_id" {
    value = aws_lb.this.zone_id
}

output "target_group_id_blue" {
    value = aws_lb_target_group.blue.id
}

# output "target_group_name_blue" {
#     value = aws_lb_target_group.blue.name
# }

# output "target_group_name_green" {
#     value = aws_lb_target_group.green.name
# }

output "listener_arn" {
    value = aws_alb_listener.this.arn
}

output "listener_ssl_arn" {
    value = aws_alb_listener.this-ssl.arn
}


output "alb_arn" {
    value = aws_lb.this.arn
}