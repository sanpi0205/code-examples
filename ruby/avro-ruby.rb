#coding:utf-8

require 'rubygems'
require 'avro'

# 写入文件
SCHEMA = <<-JSON
{ "type": "record",
    "name": "User",
    "fields" : [
    {"name": "username", "type": "string"},
    {"name": "age", "type": "int"},
    {"name": "verified", "type": "boolean", "default": "false"}
    ]}
JSON

file = File.open('data.avr', 'wb')
schema = Avro::Schema.parse(SCHEMA)
writer = Avro::IO::DatumWriter.new(schema)
dw = Avro::DataFile::Writer.new(file, writer, schema)
dw << {"username" => "john", "age" => 25, "verified" => true}
dw << {"username" => "ryan", "age" => 23, "verified" => false}
dw.close

# 读取文件
file = File.open('data.avr', 'r+')
dr = Avro::DataFile::Reader.new(file, Avro::IO::DatumReader.new)
dr.each do |record|
    puts "My name is #{record['username']} and I am #{record['age']} years old "
end