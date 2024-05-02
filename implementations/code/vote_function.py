import json
import boto3
import tempfile
import os

s3 = boto3.client('s3')
collector_bucket = os.environ["CollectorBucket"] 
results_bucket = os.environ["ResultBucket"]

def lambda_handler(event, context):
    print(json.dumps(event))
    print(collector_bucket)
    print(results_bucket)
    key = event["Records"][0]["s3"]["object"]["key"]
    print(key)
    with tempfile.TemporaryFile(mode='w+b') as f:
        s3.download_fileobj(collector_bucket, key, f)
        f.seek(0)
        data = json.loads(f.read().decode('utf-8'))
        print(data)
        # Inicializar el diccionario de resultados
        resultados = {candidato: 0 for candidato in data["candidates"]}

##Calcular los votos totales por candidato
        for ciudad in data["results"]:
            for candidato, votos in ciudad["votes"].items():
                resultados[candidato] += votos

##Calcular el total de votos
        total_votos = sum(resultados.values())

##Agregar el total de votos al diccionario de resultados
        resultados["total"] = total_votos

##Imprimir el resultado en formato JSON
        body = json.dumps(resultados, indent=4)
    # TODO implement
    print(body)
    s3.put_object(Bucket=results_bucket,Key=key,Body=body)
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }