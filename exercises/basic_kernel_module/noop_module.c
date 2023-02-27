// set tabstop=2 number nohlsearch

// Example# 2.4

// Change Synopsis
// 	extern int sub_doprintk(int, void *);

#include <linux/version.h>

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

MODULE_AUTHOR("yduchesne");
MODULE_LICENSE("GPL");


static int noop_init(void)
{
    // module init message
    printk(KERN_ALERT "Initializing noop module\n");
    return 0;
}

static void noop_exit(void)
{
    // module exit message
    printk(KERN_ALERT "Exiting noop module\n");
}

module_init(noop_init);
module_exit(noop_exit);
