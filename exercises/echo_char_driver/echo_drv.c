#include <linux/init.h>           // Macros used to mark up functions e.g. __init __exit
#include <linux/module.h>         // Core header for loading LKMs into the kernel
#include <linux/device.h>         // Header to support the kernel Driver Model
#include <linux/kernel.h>         // Contains types, macros, functions for the kernel
#include <linux/fs.h>             // Header for the Linux file system support
#include <linux/uaccess.h>          // Required for the copy to user function

#define  ECHO_DRV_DEVICE_NAME "echo_dev"    
#define  ECHO_DRV_CLASS_NAME  "echo"       
#define  ECHO_DRV_INPUT_MAX_LEN 512 

MODULE_LICENSE("GPL");            
MODULE_AUTHOR("yduchesne");    
MODULE_DESCRIPTION("Echoes back data about a provided input"); 
MODULE_VERSION("0.1");            


static int majorNumber;
static char input[ECHO_DRV_INPUT_MAX_LEN] = {0};
static short inputLen = 0;
static struct class* drvClass = NULL;
static struct device* drvDevice = NULL;

// Driver function prototypes

static int echo_open(struct inode*, struct file*);
static int echo_release(struct inode*, struct file*);
static ssize_t echo_read(struct file*, char*, size_t, loff_t*);
static ssize_t echo_write(struct file*, const char*, size_t, loff_t*);

static struct file_operations fops = 
{
    .open = echo_open,
    .release = echo_release,
    .read = echo_read,
    .write = echo_write
};

static int safe_strcpy(const char*src, char*dst, size_t srcLen, size_t dstLen)
{
    size_t actualLen = srcLen > dstLen ? dstLen : srcLen;
    size_t i = 0;
    for (; i < actualLen; i++)
    {
        *(dst + i) = *(src + i);
        if ( *(dst + i) == '\0' )
        {
            break;
        }       
    }

    // Adding EOS character
    if (i == dstLen)
    {
        *(dst + i - 1) = '\0';
    } 
    else
    {
        *(dst + i) = '\0';
    }
    return i;
}

static int __init echo_init(void)
{
    printk(KERN_INFO "echo::init - Initializing echo driver\n");

    majorNumber = register_chrdev(0, ECHO_DRV_DEVICE_NAME, &fops);
    if (majorNumber < 0)
    {
        printk(KERN_ALERT, "Failed to register echo driver: %d\n", majorNumber);
        return majorNumber;
    }
    printk(KERN_INFO, "Registered echo driver\n");

    drvClass = class_create(THIS_MODULE, ECHO_DRV_CLASS_NAME);
    if  (IS_ERR(drvClass))
    {
        unregister_chrdev(majorNumber, ECHO_DRV_DEVICE_NAME);
        printk(KERN_ALERT "Failed to register device class\n");
        return PTR_ERR(drvClass);
    }
    printk(KERN_INFO, "Registered device class\n");

    drvDevice = device_create(drvClass, NULL, MKDEV(majorNumber, 0), NULL, ECHO_DRV_DEVICE_NAME);
    if (IS_ERR(drvDevice))
    {
        class_destroy(drvClass);
        unregister_chrdev(majorNumber, ECHO_DRV_DEVICE_NAME);
        printk(KERN_ALERT, "Failed to create device class instance\n");
        return PTR_ERR(drvDevice);
    }
    printk(KERN_INFO "Created device class instance");
    return 0;
}

static void __exit echo_exit(void)
{
    printk(KERN_INFO "echo::exit - Exiting echo driver\n");
    device_destroy(drvClass, MKDEV(majorNumber, 0));
    class_unregister(drvClass);
    class_destroy(drvClass);
    unregister_chrdev(majorNumber, ECHO_DRV_DEVICE_NAME);
}

static int echo_open(struct inode* node_ptr, struct file* file_ptr)
{
    printk(KERN_INFO, "Opening echo driver\n");
    return 0;
}

static ssize_t echo_read(struct file* file_ptr, char* buffer, size_t len, loff_t* offset)
{
    printk(KERN_INFO "echo::read - Reading input from internal buffer\n");
    int errors = 0;
    errors = copy_to_user(buffer, input, inputLen);
    if (errors > 0)
    {
        printk(KERN_ALERT "Failed to send input to caller\n");
        return -EFAULT;
    }
    printk(KERN_INFO, "Sending input to caller\n");
    return 0;
}

static ssize_t echo_write(struct file* file_ptr, const char* buffer, size_t len, loff_t* offset)
{
    printk(KERN_INFO "echo::write - Copying input to internal buffer\n");
    return safe_strcpy(buffer, input, len, ECHO_DRV_INPUT_MAX_LEN);
}

static int echo_release(struct inode* node_ptr, struct file* file_ptr)
{
    printk(KERN_INFO, "echo::release - Device successfully closed\n");
    return 0;
}

module_init(echo_init);
module_exit(echo_exit);