from fuzzywuzzy import fuzz, process

def findmatch(searchKey, searchlist, topLimit):
    matches = process.extract(query=searchKey, choices=searchlist, scorer=fuzz.token_set_ratio, limit=topLimit)
    return matches


#from fuzzywuzzy import fuzz, process

## Define a global variable to store the cached choices
#cached_searchlist = []

#def findmatch(searchKey,searchlist):
#    global cached_searchlist
#    # Check if the cached searchlist is empty or not
#    if not cached_searchlist:
#        initialize_searchlist(searchlist)
#    # Use the cached searchlist for the extraction process
#    matches = process.extract(query=searchKey, choices=cached_searchlist, scorer=fuzz.token_set_ratio, limit=20)
#    return matches

#def initialize_searchlist(searchlist):
#    global cached_searchlist
#    # Initialize the cached_searchlist variable with the provided list of choices
#    cached_searchlist = searchlist
