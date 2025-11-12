# Database Assignment

## Introduction

This repository stores source code of database assignment.

## Environment

- `MySQL` - `8.0.44`

## Usage

### Setup

With `just`:

1. Set up the database:

```bash
just init
```

2. Start the server:

```bash
just start
```

3. Enter the `MySQL` shell:

```bash
just exec
```

4. Stop the server:

```bash
just stop
```

### Create Database and Tables

Run the `src/create.sql` with `MySQL` server.

```sql
SOURCE ./src/create.sql
```
