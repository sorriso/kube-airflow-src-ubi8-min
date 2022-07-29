you like this work ?

[!["You like it ?"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/sorriso)

# kube-airflow-src-ubi8-min

Kubernetes yaml configuration files for airflow build from source on UBI8-minimal base image

## prerequisite:

- Rancher desktop (or equivalent) installed locally & running with "containerd" selected as main command tool

## How to make it working :

- edit "postgres/postgres-PersistentVolume.yaml" and update 'path: "/Users/sorriso/Documents/GitHub/kube-airflow-src-ubi8-min/volume/postgres"'

- edit "redis/redis-PersistentVolume.yaml" and update 'path: "/Users/sorriso/Documents/GitHub/kube-airflow-src-ubi8-min/volume/redis"'

- edit "airflow/airflow-dags-PersistentVolume.yaml" and update 'path: "/Users/sorriso/Documents/GitHub/kube-airflow-src-ubi8-min/volume/dags"'

- edit "airflow/airflow-logs-PersistentVolume.yaml" and update 'path: "/Users/sorriso/Documents/GitHub/kube-airflow-src-ubi8-min/volume/logs"'

- edit "build/.env" and update version if / when needed (changing python version imply to change in Dockerfile the python version to be installed (python39))

- run "/build/0-build-image.sh" to pull ubi8 base image & build custom airflow image

- run "./0-pull.sh" to pull redis & postgresql docker image

- run "./1-start.sh" to start service

- run "./2-stop.sh" to stop service
