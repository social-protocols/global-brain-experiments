function create_db(path::String)::SQLite.DB
    db = SQLite.DB(path)
    DBInterface.execute(db, """
        CREATE TABLE IF NOT EXISTS posts (
              id        INTEGER PRIMARY KEY
            , parent_id INTEGER
            , content   TEXT
            , author_id INTEGER NOT NULL
            , timestamp INTEGER NOT NULL
        )
    """)
    DBInterface.execute(db, """
        CREATE TABLE IF NOT EXISTS votes (
              post_id   INTEGER NOT NULL
            , user_id   INTEGER NOT NULL
            , upvote    BOOLEAN NOT NULL
            , timestamp INTEGER NOT NULL
            , PRIMARY KEY (post_id, user_id)
        )
    """)
    DBInterface.execute(db, """
        CREATE TABLE IF NOT EXISTS personas (
              id     INTEGER PRIMARY KEY
            , name   TEXT
            , age    INTEGER
            , gender TEXT
            , job    TEXT
            , traits TEXT
        )
    """)
    return db
end


function get_db(path::String)::SQLite.DB
    if isfile(path)
        return SQLite.DB(path)
    else
        error("No database exists at path $path.")
    end
end
