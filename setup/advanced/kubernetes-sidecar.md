# Kubernetes Sidecar Container Setup

To get started with a Kubernetes sidecar container setup, simply adapt the following deployment yaml to suit your needs. Be sure to create a persistent volume and persistent volume claim for Gluetun to be able to store data!

```yaml
---
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: gluetun-deployment
   labels:
     app: gluetun
 spec:
   replicas: 1
   strategy:
       type: RollingUpdate
       rollingUpdate:
          maxSurge: 1
   selector:
      matchLabels:
        app: gluetun
   template:
     metadata:
       labels:
         app: gluetun
     spec:
      containers:
         - name: gluetun
           image: ghcr.io/qdm12/gluetun # Optionally you can use the "qmcgaw/gluetun" image as well as specify what version of Gluetun you desire
           imagePullPolicy: Always
           securityContext:
             capabilities:
               add: ["NET_ADMIN"]
           # You can optionally specify ports that are used by your containers, but it is not strictly necessary
           # ports:
             # - containerPort: 8080

           # Adapt the following environment variables to suit your needs and VPN provider
           env:
           - name: TZ
             value: "Europe/London"

           - name: VPN_SERVICE_PROVIDER
             value: "ivpn"

           - name: OPENVPN_USER
             value: ""

           - name: OPENVPN_PASSWORD
             value: ""

           # If you having connection issues, try enabling these variables to help diagnose it.
           # - name: FIREWALL_DEBUG
           #   value: "on"
           # - name: FIREWALL_INPUT_PORTS
           #   value: "8080"

           volumeMounts:
             - name: gluetun-config
               mountPath: /gluetun


           # -- Connecting Other Containers --
         # Define other containers that you want to connected to a VPN.
         # When using Gluetun in a sidecar configuration, all other containers will use Gluetun's VPN connection.
         # For testing purposes, you can `kubectl exec` into this curl container and run `curl https://ipinfo.io` to test your connection!

         - name: curl-container
           image: quay.io/curl/curl:latest
           command: ["sleep", "infinity"]

      volumes:
        - name: gluetun-config
          persistentVolumeClaim:
            claimName: pvc-gluetun-config

```

To be able to conveniently access applications connected to Gluetun (such as a WebUI or proxy) you can optionally expose ports through services! The following is an example to expose a WebUI and shadowsocks proxy through a load balancer IP address.

```yaml

---
kind: Service
apiVersion: v1
metadata:
  name: gluetun-service-tcp
  annotations:
    metallb.universe.tf/allow-shared-ip: gluetun
spec:
  selector:
    app: gluetun
  ports:
    - name: some-webui
      protocol: TCP
      port: 8080
    - name: shadowsocks-01
      protocol: TCP
      port: 8388
  type: LoadBalancer
  loadBalancerIP: 192.168.1.2

---
kind: Service
apiVersion: v1
metadata:
  name: gluetun-service-udp
  annotations:
    metallb.universe.tf/allow-shared-ip: gluetun
spec:
  selector:
    app: gluetun
  ports:
    - name: shadowsocks-02
      protocol: UDP
      port: 8388
  type: LoadBalancer
  loadBalancerIP: 192.168.1.2
```
