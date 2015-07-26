import os
import sys
import integration_lib

if __name__ == "__main__":
    curr_dir = os.getcwd()
    db_dir = curr_dir.replace("src/integration", "db/")
    integration = integration_lib.Integration(db_dir, "db_production", "db_deployment", "datawarehouse.sql")
    #integration.populate_customer()
    #integration.populate_movie()
    #integration.populate_physical_media()
    integration.populate_physical_sell() 
    #wollyhood_integration.populate_physical_sell()
    #integration.populate_movie()
    
