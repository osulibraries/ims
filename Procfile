# Foreman startup scripts
# For use in development ONLY!

# If the jetty directory doesn't exit (re-cloning directory for instance):
# run rake jetty:download / rake jetty:unzip then -> run the jar file
jetty:  if [ ! -d "./jetty" ]; then bundle exec rake jetty:download; bundle exec rake jetty:unzip; fi; sh -c 'cd jetty/; java -Djetty.port=8983 -Dsolr.solr.name="$(pwd)/solr" -Xmx512m -XX:MaxPermSize=128m -jar start.jar';
redis:  redis-server
resque: env RUN_AT_EXIT_HOOKS=true TERM_CHILD=1 QUEUE=* bundle exec rake resque:work
