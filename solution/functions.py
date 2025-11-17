import os
import pandas as pd



def import_csv_to_df(file_path: str, csv_name: str, delimiter: str = ',', index_col: str = 'raceId') -> pd.DataFrame:
    """ Use pandas to import a CSV to a dataframe and set index if required. Current working directory is set to the project root for the user.
    Args:
        file_path (str): relative path to CSV file i.e 'source-data'. 
        delimiter (str, optional): specific delimiter to use. Defaults to ','.
        csv_name (str): name of the CSV file including file extension. If the file is not found, an exception is raised.
        index_col (str, optional): name of the column to set as index. Defaults to 'raceId'.

    Returns:
        pd.DataFrame: DataFrame containing the imported CSV data
    
    Example usage:
        import_csv_to_df(file_path='source-data', csv_name='races.csv', delimiter=',', index_col='raceId')
        import_csv_to_df(file_path='/source-data/', csv_name='races.csv', delimiter=',', index_col='raceId')
        import_csv_to_df(file_path='source-data', csv_name='races.csv')
        import_csv_to_df(file_path='source-data', csv_name='races.csv', delimiter=',')
        import_csv_to_df(file_path='source-data', csv_name='races.csv', index_col='raceId')
    """
       
    """ Ensure the file path ends with a slash """
    if not file_path.endswith('/'):
        file_path += '/'
    
    
    print(f'Testing file path: {file_path+csv_name}')
    """ Ensure the file path starts with a slash and ends with a slash"""  
    if file_path.startswith('/'):
        file_path = os.getcwd() + file_path
    elif file_path.startswith('./'):
        file_path = os.getcwd() + file_path[1:]
    elif file_path.startswith('.'):
        file_path = os.getcwd() + '/' + file_path[1:]
    else: # relative path
        file_path = os.getcwd() + '/' + file_path

    df = pd.read_csv(file_path+csv_name, delimiter=delimiter)
    if index_col:
        df.set_index(keys=index_col, inplace=True)
    return df

def publish_df_to_aws_bucket_as_json(df: pd.DataFrame, bucket_name: str, file_name: str):
    """ Publish a dataframe to an AWS S3 bucket as a JSON file.
    Args:
        df (pd.DataFrame): DataFrame to publish.
        bucket_name (str): Name of the S3 bucket.
        file_name (str): Name of the file to create in the S3 bucket.
    """
    import boto3
    import io
    
    #Creating Session using Boto3
    session = boto3.Session(
            aws_access_key_id='<key ID>',           # Replace with your AWS access key ID
            aws_secret_access_key='<secret_key>',   # Replace with your AWS secret access key   
            region_name='uk-london'                 # Update AWS region as needed
    )
 
    #Create s3 session with boto3
    s3 = session.resource('s3')
    

    #Convert DataFrame to JSON and upload to S3 bucket
    json_buffer = io.StringIO()
    try:
        json_data = df.to_json(orient='records', date_format='iso')
        s3.put_object(Bucket=bucket_name, Key=file_name, Body=json_data)
        print(f"Successfully published {file_name} to bucket {bucket_name}.")
    except Exception as e:
        print(f"An error occurred: {e}")