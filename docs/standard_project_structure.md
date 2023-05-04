# Standard project directory structure

```bash
project/
|-- data/                           # raw and processed data used in the project.
|   |-- processed/                  # the cleaned and encoded data files, such as credit_data_cleaned.csv and credit_data_encoded.csv.
|   |-- raw/                        # the original data files, such as credit_data.csv.
|   |-- README.md                   # documentation related to the data.
|-- models/                         # models built.
|   |-- baseline_model.joblib       # baseline model: output of src/models/baseline_model.py.
|   |-- final_model.joblib          # final model: output of src/models/final_model.py.
|-- docs/                           # documentation for the project, such as project requirements, design documents, and user guides.
|-- notebooks/                      # Jupyter notebooks for each stage of the workflow.
|   |-- exploration/                # notebooks related to data exploration.
|   |   |-- data_exploration.ipynb  # the code for exploring and visualizing the data.
|   |   |-- data_preparation.ipynb  # the code for cleaning and encoding the data.
|   |-- modeling/                   # notebooks related to modelling.
|   |   |-- model_training.ipynb    # the code for training and tuning the models.
|   |   |-- model_evaluation.ipynb  # the code for evaluating the performance of the models.
|   |-- README.md                   # documentation related to the notebooks.
|-- opt/                            # optional code for the project
|   |-- requirements.txt
|-- src/                            # source code for the project.
|   |-- data/                       # code for data loading, cleaning, and transformation.
|   |-- features/                   # code for feature engineering
|   |-- models/                     # code for building and evaluating machine learning models.
|   |   |-- baseline_model.py       # the code for the baseline model.
|   |   |-- final_model.py          # the code for the final model.
|   |-- utils/                      # utility functions used throughout the project
|   |-- __init__.py                 # a file that makes the src directory a Python package.
|   |-- README.md                   # documentation related to the source code.
|-- tests/                          # code for testing the project.
|   |-- README.md                   # documentation related to the source code.
|-- README.md                       # title-page: a brief description of the project.
|-- LICENSE                         # the license under which the project is distributed.
|-- Dockerfile
|-- docker-compose-yml
```