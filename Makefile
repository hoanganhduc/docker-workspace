all:
	git add --all .
	git commit -S -m "Source Files @ $(shell date +'%Y-%m-%d  %H:%M:%S')"
	git push -u origin master
