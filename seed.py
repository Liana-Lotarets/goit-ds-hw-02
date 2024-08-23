import faker
from random import randint
import sqlite3

# For Table: users
NUMBER_USERS = 5
# For Table: tasks
NUMBER_TASKS = 20


def generate_fake_data(number_users: int, number_tasks: int) -> tuple:
    """
    We need to generate:

    For Table: users
    - fake_fullnames (NUMBER_FULLNAMES == NUMBER_USERS)
    - fake_emails (NUMBER_EMAILS == NUMBER_USERS)

    # For Table: tasks
    - fake_titles (NUMBER_TITLES == NUMBER_TASKS)
    - fake_descriptions (NUMBER_DESCRIPTION == NUMBER_TASKS)
    """
    fake_fullnames_and_emails = []
    fake_titles_and_descriptions = []
    fake_data = faker.Faker()

    for _ in range(number_users):
        fake_fullnames_and_emails.append((fake_data.name(), fake_data.email()))

    for _ in range(number_tasks):
        fake_titles_and_descriptions.append(
            (fake_data.catch_phrase(), fake_data.text())
        )

    return fake_fullnames_and_emails, fake_titles_and_descriptions


def prepare_data(fullnames_and_emails: tuple, titles_and_descriptions: tuple) -> tuple:
    # For Table: users
    for_users = []
    for name_and_email in fullnames_and_emails:
        for_users.append(name_and_email)

    # For Table: status
    for_status = [("new",), ("in progress",), ("completed",)]

    # For Table: tasks
    for_tasks = []
    for title_and_description in titles_and_descriptions:
        for_tasks.append(
            (
                title_and_description[0],
                title_and_description[1],
                randint(1, 3),
                randint(1, NUMBER_USERS),
            )
        )

    return for_users, for_status, for_tasks


def insert_data_to_db(users, status, tasks) -> None:

    with sqlite3.connect("task_management.db") as con:

        cur = con.cursor()

        # For Table: users
        sql_to_users = """INSERT INTO users(fullname, email)
                               VALUES (?, ?)"""
        cur.executemany(sql_to_users, users)

        # For Table: status
        sql_to_status = """INSERT INTO status(name)
                               VALUES (?)"""
        cur.executemany(sql_to_status, status)

        # For Table: tasks
        sql_to_tasks = """INSERT INTO tasks(title, description, status_id, user_id)
                              VALUES (?, ?, ?, ?)"""
        cur.executemany(sql_to_tasks, tasks)

        con.commit()


if __name__ == "__main__":
    users, status, tasks = prepare_data(*generate_fake_data(NUMBER_USERS, NUMBER_TASKS))
    insert_data_to_db(users, status, tasks)
