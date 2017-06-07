Repository to show that `Sinatra::Streaming` and `rubyzip` are not compatible

1) `rubyzip` allows to create zip files using `write_buffer`. This takes an IO like object (e.g. `StringIO`). When passing
  in the `out` from `stream {|out|...}` it fails because of:
    1) Missing `reopen` method in `out`
    2) `rubyzip` dups the IO passed into `write_buffer`, because of this the mixin are not "copied"
2) After fixing the issues in 1 the generated zip is invalid and contains some extra bytes. Can't figure out what...

To install:
```
git clone git@github.com:lvonk/streaming_zip.git
bundle install
```

To test issue 1:

```
ruby app.rb
```

Open a browser and to http://localhost:4567

To test issue 2:

```
ruby app-patch.rb
```

Open a browser and to http://localhost:4567

Download the zips from both links. Only the `files-buffer.zip` opens.

Output for the `files.zip`

```
sparky:Downloads Lars$ unzip -l files.zip 
Archive:  files.zip
warning [files.zip]:  76 extra bytes at beginning or within zipfile
  (attempting to process anyway)
  Length      Date    Time    Name
---------  ---------- -----   ----
        5  06-07-2017 16:57   foo1.txt
        5  06-07-2017 16:57   foo2.txt
---------                     -------
       10                     2 files
```
