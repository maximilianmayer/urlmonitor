# pagemonitor
A simple monitor for tracking changes on single webpages

## usage

use cli.rb to run pagemonitor. Syntax is as easy as possible, just provide a url. 

### example
check a page which hasn't been checked before.
```bash
$ ./cli.rb https://www.google.com
Website to check: https://www.google.com
last checked: 2020-04-22 12:06:49 +0200
http status: 200
check status: new
```



## planned features
- manage pages (add, remove)
- run as webservice
- run scheduled page checks
- alerting via telegram
- some (nice) web-ui
