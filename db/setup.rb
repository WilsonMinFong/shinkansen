require_relative '../lib/model/db_connection'

DBConnection.setup('messages.db', 'messages.sql')
