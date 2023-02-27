# set tabstop=2 number nohlsearch

CONFIG_MODULE_SIG=n

OBJ1 := noop_module

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

LDD := /lib/modules/$(shell uname -r)/kernel/drivers/ldd/

obj-m := $(OBJ1).o

all: load 
	@sudo make -s clean

all2: modprobe 
	@sudo make -s clean

run:  load unload clean

runall:  modprobe unloadall clean

compile:
	@sudo $(MAKE) -C $(KDIR) M=$(PWD) modules 

###  Alternative, archaic syntax
###  $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules 

load:	compile
	@echo "try \"tail -f /var/log/messages\" in another window(as root) ..";
	sudo su -c "insmod ./$(OBJ1).ko" 
	lsmod | egrep "$(OBJ1)|$(OBJ2)"
	tail /lib/modules/`uname -r`/modules.dep
	grep -F \[$(OBJ1) /proc/kallsyms
	-ls -ld /sys/module/$(OBJ1)


modprobe: compile
	-sudo su -c "mkdir -p $(LDD); cp $(OBJ1).ko $(LDD); depmod -A;";
	@echo "try \"tail -f /var/log/messages\" in another window(as root) ..";
	lsmod | egrep "$(OBJ1)"
	tail /lib/modules/`uname -r`/modules.dep

unload: 
	-sudo su -c "rmmod $(OBJ1);";

unloadall: 
	-@sudo su -c "rm -f $(LDD)/*; [ -d $(LDD) ] && { rmdir $(LDD); };"
	-(sleep 2; depmod -A; sync; sync;) &
	-lsmod | egrep "$(OBJ1)"
	-tail /lib/modules/`uname -r`/modules.dep

clean: unload 
	-@sudo su -c "rm -f $(LDD)/*; [ -d $(LDD) ] && { rmdir $(LDD); };"
	-@rm -f *.o *.ko .tmp_versions* [mM]odule* *.mod *.ko.* .[mM]odule* .cache.mk *.cmd .*.cmd *.mod.c
	-@rm -fr .tmp_versions*
