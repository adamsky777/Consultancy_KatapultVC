import time, os, mysql.connector, pandas as pd
from tqdm import tqdm
from dotenv import load_dotenv

load_dotenv()  # loads variables from .env
# Replace .env values with your database information
host = os.getenv("DB_HOST")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
database = os.getenv("DB_DATABASE")


def query_from_db(query, chunk_size=50000):
    # Establish the connection
    connection = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )

    try:
        # Check if the connection is successful
        if connection.is_connected():
            print(f"Connected to {database} database")

            # Start the timer
            start_time = time.time()

            # Create a generator function to fetch data in chunks
            def chunk_generator():
                offset = 0
                while True:
                    chunk_query = f"{query} LIMIT {chunk_size} OFFSET {offset}"
                    chunk = pd.read_sql_query(chunk_query, connection)
                    if chunk.empty:
                        break
                    yield chunk
                    offset += chunk_size

            # Create a tqdm instance
            tqdm_bar = tqdm(desc="Query Progress", unit=" row")

            # Perform database operations here
            data_frames = []
            for chunk in chunk_generator():
                data_frames.append(chunk)
                tqdm_bar.update(len(chunk))

            # Combine all chunks into a single DataFrame
            data_frame = pd.concat(data_frames, ignore_index=True)

            # Close tqdm
            tqdm_bar.close()

            # Stop the timer
            end_time = time.time()
            elapsed_time = end_time - start_time
            print(f"Query took {elapsed_time:.2f} seconds")

            # You can perform additional operations on the DataFrame if needed

            return data_frame

    except Exception as e:
        print(f"Error: {e}")

    finally:
        # Close the connection when done
        connection.close()
        print("Connection closed")


def insert_into_db(insert_query, values):
    connection = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )

    try:
        cursor = connection.cursor()

        cursor.executemany(insert_query, values)
        connection.commit()

        print(f"{cursor.rowcount} rows inserted")

    except Exception as e:
        print(f"Error: {e}")
        connection.rollback()

    finally:
        connection.close()

# Example usage:
#query = "SELECT * FROM your_table"
#result_df = query_from_db(query)
"""
query = "INSERT INTO users (name, age) VALUES (%s, %s)"
data = [
    ("Alice", 25),
    ("Bob", 30)]
insert_into_db(query, data)
"""


