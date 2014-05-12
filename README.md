posthaven_forward_attachment
============================

forwards new photo blog images as email attachments daily.  i use this to send posthaven photos to a nixplay frame, but it should work for other feeds too.  to setup, first sign up for heroku and clone this repo then:

# create
```
cd posthaven_forward_attachment
heroku create
git push heroku master
```

# setup
```
heroku addons:add mandrill
heroku addons:add scheduler:standard
heroku addons:open scheduler # create a job to run bin/posthaven_forward_attachment.rb daily at any time
```

# configure
```
heroku config:set FEED_URL=http://youraccount.posthaven.com/posts.atom
heroku config:set MY_EMAIL=your@email.com
heroku config:set TO_EMAIL=youraccount@mynixplay.com
```

# test
```
heroku run bin/posthaven_forward_attachment.rb
```