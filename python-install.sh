cd ~/
mkdir python-matrix-core-app
cd python-matrix-core-app

wget "https://github.com/matrix-io/matrix-creator-malos/blob/master/src/python_test/Pipfile" -O Pipfile
wget "https://github.com/matrix-io/matrix-creator-malos/blob/master/src/python_test/Pipfile.lock" -O Pipfile.lock
wget "https://raw.githubusercontent.com/matrix-io/matrix-creator-malos/master/src/python_test/requirements.txt" -O requirements.txt 
wget "https://raw.githubusercontent.com/matrix-io/matrix-creator-malos/master/src/python_test/utils.py" -O utils.py 
sudo apt-get install build-essential python-dev

pip install -r requirements.txt

