#! /bin/bash

kubectl get -n istio-system cm istio-1-14 -ojson > adaptor.json
echo -e "import json\nwith open('adaptor.json','r') as ofile:\n\to_data = json.load(ofile);\n\to_data['data']['mesh']= 'configSources:\\\n- address: xds://nacos-cs.default:18848\\\n' + o_data['data']['mesh']\nwith open('adaptor_.json','w') as dfile:\n\tjson.dump(o_data,dfile)" > patch.py
python patch.py
kubectl -n istio-system apply -f adaptor_.json
kubectl delete -n istio-system "$(kubectl get -n istio-system -l app=istiod po -oname)"
rm ./*.json ./*.py