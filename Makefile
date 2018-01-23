.PHONY : docker start stop restart bash log

docker:
	@docker run --rm --privileged --pid=host walkerlee/nsenter -t 1 -m -u -i -n ntpd -d -q -n -p a.ntp.br
	@docker-compose build
	# @docker-compose up -d fakesmtp
	@docker-compose run fakesmtp bash

start:
	@docker run --rm --privileged --pid=host walkerlee/nsenter -t 1 -m -u -i -n ntpd -d -q -n -p a.ntp.br
	@docker-compose start
	@docker-compose run fakesmtp bash

stop:
	@docker-compose stop

restart:
	@docker-compose restart fakesmtp

log:
	@docker-compose logs -f --tail=0

bash:
	@docker exec -it `docker-compose ps | grep entregador_entregador | cut -d " " -f 1` bash

clean:
	@docker-compose down
	@docker system prune --volumes --force
