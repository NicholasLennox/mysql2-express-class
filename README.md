# Express mysql2 integration
This is a simple project that shows how to to integrate mysql2 with express and EJS. It uses the express-generator template to manage channels.

## Installation

First clone the repo:
```bash

```

Navigate into the project and install the required dependencies:

```bash
cd
```

```bash
npm i 
```

You may need to also force update to the latest packages for security vulnerabilities:

```bash
npm audit fix --force
```

Then run the application:

```bash
npm start
```

### Database

The `db.sql` script file includes the schema, data, and stored procedures using for this 

## Application

The home page just lists channels. From here you can:

- Add a new channel via a add view
- Edit an existing channel via an edit view
- Delete an existing channel. This is a soft delete and simply changes the `is_deleted` flag to true.  