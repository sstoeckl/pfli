import pickle
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.linear_model import LinearRegression
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import RandomizedSearchCV

regressor1 = pickle.load(open("/home/rstudio/ShinyApps/pfli/models/Linear_Model_2020-11-20.sav", 'rb'))

def pred1(x):
  return(regressor1.predict(x))

regressor2 = pickle.load(open("/home/rstudio/ShinyApps/pfli/models/KNN_Model_2020-11-20.sav", 'rb'))

def pred2(x):
  return(regressor2.predict(x))
