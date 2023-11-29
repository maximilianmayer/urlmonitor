# urlmonitor
A simple monitor for tracking changes on single webpages

## usage

use bin/urlmon to run urlmonitor.
Since version 0.3 urlmon is available as gem ,so calling the executable 'urlmon' should be available in your path.

The syntax is as easy as possible.

There are some options available: `init`, `check`, `list`and `delete`.

You need to run init to properly initialize urlmon, which creates the .urlmon directory and a base index.json in it. After that you are ready to go.

### examples


list all known urls
```shell script
$ urlmon  list
URL monitor - v0.3.0
id    last check Date                             URL
1     2023-11-24 15:43:21 +0100  (21h 19m 21s)    https://www.codecentric.de/
$
```

check a url which hasn't been checked before.
```shell script
$ urlmon check --url https://www.google.com
URL monitor - v0.3.0
>>>
URL to check: https://www.google.com
last checked: 2023-11-29 12:58:10 +0100
http status: 200
check status: new
checksum: 77fd2e2c0516a80fcd0eb74da126a182
$
```

re check a url by it's id.
```shell script
urlmon check --id 10
URL monitor - v0.3.0
selected ID : 10
>>>
URL to check: https://www.google.com
last checked: 2023-11-29 12:59:12 +0100
http status: 200
check status: no changes
checksum: 77fd2e2c0516a80fcd0eb74da126a182
$
```




## planned features
- manage pages (add, remove)
- run as webservice
- run scheduled page checks
- alerting via telegram
- some (nice) web-ui


## Changelog

### 0.3.0

