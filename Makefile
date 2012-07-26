all:
	make -j 2 compile

install:
	npm install
	npm install -g ender
	cd public/javascripts && ender build jeesh reqwest underscore
	git submodule update --init

compile: coffeeserver coffeeclient

coffeeclient:
	./node_modules/coffee-script/bin/coffee -wo ./public/javascripts -c ./public/javascripts

coffeeserver:
	./node_modules/coffee-script/bin/coffee -wo ./code -c ./code

coffeeonce:
	./node_modules/coffee-script/bin/coffee -o ./public/javascripts -c ./public/javascripts
	./node_modules/coffee-script/bin/coffee -o ./code -c ./code

gitinstall: install coffeeonce
