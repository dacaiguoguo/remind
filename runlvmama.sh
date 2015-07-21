kill -9 `cat /tmp/django.pid`
echo 'restart django....'

python /tmp/remind/lvmama/manage.py runfcgi maxchildren=8  maxspare=3 minspare=1 method=prefork  pidfile=/tmp/django.pid host=127.0.0.1 port=9001 outlog=/tmp/dj.out errlog=/tmp/dj.error
