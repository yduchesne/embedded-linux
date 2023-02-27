KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

DRV_CLASS_NAME := echo
DRV_NAME := $(DRV_CLASS_NAME)_dev
DRV_SRC_NAME := $(DRV_CLASS_NAME)_drv

obj-m := $(DRV_SRC_NAME).o


compile:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

load: compile 
	-sudo insmod ./$(DRV_SRC_NAME).ko
	-ls -l /dev/$(DRV_NAME)*

run: load
	echo "Hello World" > /dev/$(DRV_NAME)
	cat < /dev/$(DRV_NAME);

unload:
	-sudo rmmod $(DRV_NAME) && sudo rm -f /dev/$(DRV_NAME)*

clean: unload
	-@sudo rm -fr *.o *.ko .tmp_versions [mM]odule* *.mod .cache.mk .modules.order.cmd .Module.symvers.cmd
	-pkill udevadm

all: clean compile run 
	-ls -l /dev/$(DRV_NAME)*
	-ls -l /sys/class/$(DRV_CLASS_NAME)/$(DRV_NAME)
	-cat /sys/class/$(DRV_CLASS_NAME)/$(DRV_NAME)/uevent
	@make -s clean

