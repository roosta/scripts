dir_guard=@mkdir -p $(@D)

bin/xidle:
	$(dir_guard)
	cc -lX11 -lXext -lXss xidle.c -o $@
