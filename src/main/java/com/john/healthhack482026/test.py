import requests,json

for i in range(100):
    r = requests.request(method="post", url='http://localhost:8080/register', data=json.dumps({"username": f"hello{i}", "password": "hello234"}),
                        headers={"content-type": "application/json"})

# r = requests.request(method="get", url='http://localhost:8080/symptoms', data=json.dumps(payload),
                    #  headers={"content-type": "application/json"})
    print(r.text)