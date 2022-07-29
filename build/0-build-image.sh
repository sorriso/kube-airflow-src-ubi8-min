start=`date +%s`

# Local .env
if [ -f .env ]; then
    # Load Environment Variables
    export $(cat .env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

rm ./build.log

nerdctl -n k8s.io pull registry.access.redhat.com/ubi8/ubi-minimal:$UBI8_MIN_VERSION

nerdctl rmi -f l_airflow:latest
nerdctl build \
   --build-arg ARG_UBI8_MIN_VERSION=${UBI8_MIN_VERSION} \
   --build-arg ARG_AIRFLOW_VERSION=${AIRFLOW_VERSION} \
   --build-arg ARG_DUMBINIT_VERSION=${DUMBINIT_VERSION} \
   --build-arg ARG_PYTHON_VERSION=${PYTHON_VERSION} \
   --no-cache \
   --namespace k8s.io \
   -t l_airflow:latest . 2> ./build.log

end=`date +%s`

runtime=$((end-start))
runtimeh=$((runtime/60))
runtimes=$((runtime-runtimeh*60))

echo "Total runtime was : $runtimeh minutes $runtimes seconds"
echo "" >> ./build.log
echo "Total runtime was : $runtimeh minutes $runtimes seconds" >> ./build.log
echo ""
