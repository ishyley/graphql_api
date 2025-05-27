import 'package:flutter/widgets.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


    final HttpLink _httpLink = HttpLink(  "https://countries.trevorblades.com/graphql");


    
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: _httpLink, cache: GraphQLCache(store: InMemoryStore()))
    );
 
 
 

