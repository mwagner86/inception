# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mwagner <mwagner@student.42wolfsburg.de>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/28 18:55:48 by mwagner           #+#    #+#              #
#    Updated: 2024/02/03 14:14:43 by mwagner          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME           := inception
DOCKER         := docker
DOCKER_COMPOSE := srcs/docker-compose.yml

all: volume add_unix_entry up

up:
	${DOCKER} compose -f $(DOCKER_COMPOSE) up --build -d

down:
	${DOCKER} compose -f $(DOCKER_COMPOSE) down

prune:
	${DOCKER} system prune --all --volumes

volume:
	mkdir -p /home/max/data/wordpress
	mkdir -p /home/max/data/mariadb

del_volume:
	rm -rf /home/max/data/wordpress
	rm -rf /home/max/data/mariadb

add_unix_entry:
	echo "127.0.0.1 mwagner.42.fr" >> /etc/hosts
	echo "127.0.0.1 www.mwagner.42.fr" >> /etc/hosts

ls:
	${DOCKER} ps -a

logs:
	${DOCKER} compose -f $(DOCKER_COMPOSE) logs

fclean: down del_volume

re: fclean all
