# OpenShift Ruby Passenger Example

## How to Deploy

### Create New OpenShift Project
```
$ oc new-project example-ruby-passenger-helloworld
```

#### Create Application and expose Service
```
$ oc new-app https://github.com/phil-pona/ruby-passenger-ose3.git  --strategy=docker --name=appuio-ruby-pass-ex

$ oc expose service appuio-ruby-pass-ex
```

