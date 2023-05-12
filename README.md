# Credit Risk Modelling

This is a case study to build a supervised learning model to predict the probability of default. The model is then exposed with an AWS API Endpoint, and can be used to make predictions through API calls.

**Keywords:** Regression, LightGBM, Docker, AWS-ECR, AWS-EC2, REST-API

## Project structure

```bash
credit-risk-modelling/
|-- data/                           # raw and processed data used in the project.
|   |-- raw/                        # the original data files, such as credit_data.csv.
|   |   |-- dataset.csv             
|   |   |-- template.csv            
|   |-- predictions/                # the predictions of the model.
|   |   |-- test_predictions.csv            
|-- models/                         # models built.
|   |-- model.joblib
|-- docs/                           # documentation for the project, such as project requirements, design documents, and user guides.
|-- notebooks/                      # Jupyter notebooks for each stage of the workflow.
|   |-- exploration/                # notebooks related to data exploration.
|   |   |-- data_exploration.ipynb  # the code for exploring and visualizing the data.
|   |-- modelling/                  # notebooks related to data modelling.
|   |   |-- data_modelling.ipynb    # the code for modelling.
|-- opt/                            # optional code for the project
|   |-- requirements.txt            # pre-requisite pip-installable packages
|-- src/                            # source code for the project.
|   |-- train.py                    # the code for the final model.
|   |-- constants.py                # the code for the features.
|   |-- server.py                   # the code query the REST API.
|   |-- __init__.py                 # a file that makes the src directory a Python package.
|-- tests/                          # code for testing the project.
|   |-- __init__.py                 # a file that makes the tests directory a Python package.
|   |-- make_predictions_with_api.py # a file to make predictions using the API.
|   |-- send_valid_request.sh       # a file that makes sure that API works (sends to localhost:5001).
|-- README.md                       # title-page: a brief description of the project.
|-- LICENSE                         # the license under which the project is distributed: MIT License
|-- Dockerfile                      # Dockerfile [created image ~2GB]
|-- docker-compose.yaml
```

**Disclaimer:** The datasets were confidential and are not included here. However, this code can be also run, with appropriate dataset-specific adjustments, on standard Kaggle datasets, eg, [here](https://www.kaggle.com/datasets/uciml/default-of-credit-card-clients-dataset).

## Dependencies

1. Docker
2. Docker Compose
3. Terraform
4. curl (optional)

## Workflow

1. Create and ECR repository on AWS

**Note**: You need to do this step only once. There is no need to run this step during the subsequent releases

```bash
$ aws ecr create-repository --repository-name credit-risk-modelling
```

Set environmental variable which will indicate the registry that should be used. For example

```bash
export DOCKER_REGISTRY=166783209982.dkr.ecr.eu-north-1.amazonaws.com
```
**Note:** This container does not exist anymore. The user of the code would need to create a new EC2 repository and redirect the `${DOCKER_REGISTRY}` variable accordingly.

2. Build docker image

```bash
$ docker-compose build
```

3. Train the prediction model

```bash
$ docker-compose run train-model
```

In addition to training the model and storing it in the `models/` folder this script will create a `data/test_predictions.csv` file which contains predictions for the test data. Quality of the model could be assessed from the cross validation scores.

4. Test REST API server

```bash
$ docker-compose up rest-api
```

Send test request in order to make sure that API works (sends to localhost:5001)

```bash
$ ./tests/send_valid_request.sh
{
  "default_probability": 0.004957802768308741,
  "prediction_eta": 0.013872385025024414,
  "status": "success"
}
```

**Note**: You can also check that the `docker-compose up rest-api-prod` command works as well (Change localhost:5001 --> localhost:80)

5. Push docker model to ECR

**Note**: Image needs to be rebuild because of the pre-trained model.

```bash
$ $(aws ecr get-login --no-include-email --region eu-central-1)
$ docker-compose build
$ docker-compose push
```

6. Deploy REST API with Terraform on EC2

First, you need to specify `*.pem` key that could be used to SSH to the machine. By default, the terraform script will be looking for the `credit-risk-modelling-key` in the `~/.ssh/credit-risk-modelling-key.pem`, but the name of the key could be changed.

```bash
$ export TF_VAR_docker_registry=$DOCKER_REGISTRY
$ export TF_VAR_key_pair_name="credit-risk-modelling-key"  # or some other name of the key
$ terraform init
$ terraform apply
```

7. In the terraform logs check IP address of the machine and checks the API

## Run jupyter notebook

```bash
$ docker-compose up notebook
```

## Example on how to use the API

```python
import requests

# All features from the dataset.csv file with the same names (API will select important features)
features = {"age": 59, "merchant_group": "Entertainment", ...}
response = requests.post("http://ip-address/estimate-default-probability", json=features)
response_json = response.json()
```

## Model

The model is a gradient boosted trees based on the lightgbm package with a 10-fold cross validation score of 0.912 ROC AUC.

## Acknowledgements
A big shout-out to https://github.com/itdxer/klarna-task, which I used as the basis for my investigations.
