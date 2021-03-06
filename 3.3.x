[buildout]
extends = http://dist.plone.org/release/3.3.4/versions.cfg
versions = versions
parts = 
    bootstrap
    haproxy
    haproxy-conf
    supervisor
    instance1
    instance2
    zope2
    zeo

[env]
recipe = gocept.recipe.env

[gid]
recipe = collective.recipe.grp

[bootstrap]
recipe = collective.recipe.bootstrap

[haproxy]
recipe = plone.recipe.haproxy

[haproxy-conf]
recipe = collective.recipe.template
input = http://svn.aclark.net/svn/public/buildout/haproxy/trunk/templates/haproxy.cfg.in
output = etc/haproxy.cfg
user = ${env:USER}
group = ${gid:GROUP}

[instance1]
recipe = plone.recipe.zope2instance
zope2-location = ${zope2:location}
user = admin:admin
http-address = ${ports:instance1}
zeo-client = true
eggs = 
    Plone

[instance2]
<= instance1
http-address = ${ports:instance2}

[zope2]
recipe = plone.recipe.zope2install
url = ${versions:zope2-url}

[zeo]
recipe = plone.recipe.zope2zeoserver
zope2-location = ${zope2:location}

[supervisor]
recipe = collective.recipe.supervisor
port = ${ports:supervisor}
serverurl = ${hosts:localhost}:${supervisor:port}
programs = 
    0 haproxy ${buildout:directory}/bin/haproxy [ -f ${buildout:directory}/etc/haproxy.cfg -db ]
    0 instance1 ${instance1:location}/bin/runzope
    0 instance2 ${instance2:location}/bin/runzope
    0 zeo ${zeo:location}/bin/runzeo

[hosts]
localhost = 127.0.0.1

[ports]
haproxy = 8080
instance1 = 8081
instance2 = 8082
zeo = 8083
supervisor = 8084
