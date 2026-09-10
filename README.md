# x-port-program
This is the repo for the final application for the Xport program

---------------------------------
Install Python and the Virtual Environment

```
 - sudo apt update 
 - python3 -m venv venv
    The venv installed did not have the 'activate' script

 - apt install python3.14-venv
    - source venv/bin/activate

 - pip install Flask
    - pip freeze > requirements.txt

 - pip install pytest
    - grep pytest requirements.txt

Validation commands:
    which python
    python --version
    pip --version
```
--------------------------------
## Docker
```
run docker desktop from your local machine [Download Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)
```
```
docker build -t xport-app .
```
```
docker run -d -p 5500:5500 xport-app
```
