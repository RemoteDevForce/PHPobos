#!/bin/bash
# Set the cluster name
echo ECS_CLUSTER=${env_name}-${app_name}-ecs >> /etc/ecs/ecs.config

# Delete stopped containers every 15mins
#echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=15m >> /etc/ecs/ecs.config

# Check every 10 minutes to delete upto 10 images every 15 minutes that are old.
#echo ECS_IMAGE_CLEANUP_INTERVAL=10m >> /etc/ecs/ecs.config
#echo ECS_IMAGE_MINIMUM_CLEANUP_AGE=15m >> /etc/ecs/ecs.config
#echo ECS_NUM_IMAGES_DELETE_PER_CYCLE=10 >> /etc/ecs/ecs.config

# Configure Logging
#echo ECS_DATADIR=/data >> /etc/ecs/ecs.config
#echo ECS_ENABLE_TASK_IAM_ROLE=true >> /etc/ecs/ecs.config
#echo ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true >> /etc/ecs/ecs.config
#echo ECS_LOGFILE=/log/ecs-agent.log >> /etc/ecs/ecs.config
#echo ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"] >> /etc/ecs/ecs.config
#echo ECS_LOGLEVEL=info >> /etc/ecs/ecs.config

#yum install -y aws-cfn-bootstrap wget aws-cli jq git