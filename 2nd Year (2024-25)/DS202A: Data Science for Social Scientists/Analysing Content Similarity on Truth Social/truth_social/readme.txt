Data files structure
----------------------
Driving this dataset is a network of users connected to their posts ("Truths"). The Truths are then
connected to other entities (hashtags, quotes, replies, media, external_urls) that give more context about the information contained in each Truth.
All files are tab-separated and encoded using UTF-8.

A breakdown of the number of data points for each file:
users.tsv:  454,458
follows.tsv: 4,002,115
truths.tsv: 845,060
quotes.tsv: 10,508
replies.tsv: 506,276
media.tsv: 184,884
hashtags.tsv: 21,599
external_urls.tsv: 173,947
truth_hashtag_edges.tsv: 213,295
truth_media_edges.tsv: 257,500
truth_external_url_edges.tsv: 252,877
truth_user_tag_edges.tsv: 145,234

--------------------------------------------
Terms to Know
--------------------------------------------
Truth - Truth Social's term for a post. Near-equivalent to a Tweet.
ReTruth - Truth Social's equivalent to a retweet. When a user ReTruths a Truth, that original Truth appears on their posts, but the ReTruth cannot be
liked, ReTruthed, or replied to (one can only perform these actions on the original Truth) 

--------------------------------------------
users.tsv file structure
--------------------------------------------
|id|timestamp|time_scraped|username|follower_count|following_count|profile_url|finished_follower_scrape|finished_following_scrape|finished_truth_scrape
id - unique integer id 
timestamp - datetime of the listed user creation date (note that Truth Social only provides the month and year a user's profile was create)
time_scraped - datetime of when the user's profile was last scraped
username - text of the user's username
follower_count - int of the number of followers listed for the user
following_count - int of the number of users the user is listed as following
profile_url - text of the url of the user's profile
finished_follower_scrape - boolean indicating if the user's followers have been entirely scraped at least once
finished_following_scrape - boolean indicating if the user's following have been entirely scraped at least once
finished_truth_scrape - boolean indicating if the user's truths have been entirely scraped at least once
--------------------------------------------
follows.tsv file structure
--------------------------------------------
id|time_scraped|follower|followed
id - unique integer id 
time_scraped - datetime of when the edge was added to the data
follower - int foreign key referencing the follower user
followed - int foreign key referencing the followed user
--------------------------------------------
truths.tsv file structure
--------------------------------------------
id|timestamp|time_scraped|is_retruth|is_reply|author|like_count|retruth_count|reply_count|text|external_id|url|truth_retruthed
id - unique integer id 
timestamp - datetime of when the Truth was posted
time_scraped - datetime of when the Truth was added to the data
is_retruth - boolean indicating whether the Truth is a ReTruth
is_reply - boolean indicating whether the Truth is a reply
author - int foreign key referencing the user who posted the Truth
like_count - int of number of likes associated with Truth at time of scrape
retruth_count - int of number of ReTruths associated with Truth at time of scrape
text - text of truth
external_id -  int of Truth Social's unique id associated with Truth
url - text of url to Truth
truth_retruthed - int foreign key to Truth current Truth is ReTruthing. If the current Truth is not a ReTruth, this field is set to -1
--------------------------------------------
quotes.tsv file structure
--------------------------------------------
id|timestamp|time_scraped|quoted_user|quoting_user|quoting_truth|quoted_truth_external_id
id - unique integer id 
timestamp - datetime of when the Truth was posted
time_scraped - datetime of when the quote was added to the data
quoted_user - int foreign key to the quoted user
quoting_user - int foreign key to the quoting user
quoting_truth - int foreign key to the quoting Truth
quoted_truth_external_id - int of the Truth Social's unique id of the quoted Truth
--------------------------------------------
replies.tsv file structure
--------------------------------------------
id|time_scraped|replying_user|replied_user
id - unique integer id 
time_scraped - datetime of when the reply was added to the data
replying_user - int foreign key to the replying user
replied_user - int foreign key to the replied user
--------------------------------------------
media.tsv file structure
--------------------------------------------
id|media_url|
id - unique integer id 
media_irl - text of the media's url
--------------------------------------------
hashtags.tsv file structure
--------------------------------------------
id|first_seen|hashtag|
id - unique integer id 
first_seen - datetime of when the hashtag was first added to the data
hashtag - text of the url
--------------------------------------------
external_urls.tsv file structure
--------------------------------------------
id|url|
id - unique integer id 
url - text of the external url
--------------------------------------------
truth_media_edges.tsv file structure
--------------------------------------------
id|truth_id|media_id|
id - unique integer id 
truth_id - int foreign key of the referenced truth
media_id - int foreign key of the referenced media
--------------------------------------------
truth_hashtag_edges.tsv file structure
--------------------------------------------
id|truth_id|hashtag_id|
id - unique integer id 
truth_id - int foreign key of the referenced truth
hashtag_id - int foreign key of the referenced hashtag
--------------------------------------------
truth_external_url_edges.tsv file structure
--------------------------------------------
id|truth_id|url_id|
id - unique integer id 
truth_id - int foreign key of the referenced truth
url_id - int foreign key of the referenced url
--------------------------------------------
truth_user_tag_edges.tsv file structure
--------------------------------------------
id|time_scraped|truth_id|user_id
id - unique integer id 
time_scraped - datetime of when the entry was added to the data
truth_id - int foreign key of the referenced truth
user_id - int foreign key of the tagged user


--------------------------------------------
Significant information about the Data
--------------------------------------------
Due to Truth Social's query limitations, not all users.tsv and truths.tsv data points were pulled directly from Truth Social.

- For truths: in order to link ReTruthing Truths to their original Truths, during the data-cleaning phase,
    if a Truth is a ReTruth, and its originally referenced Truth did not exist in the data, an entry was created for the original Truth. This entry, however, lacked the Truth's original timestamp.
    To indicate that this information is missing, a timestamp of -1 is listed.
- For users: in order to ensure that all follow edges reference a user entry, during the data-cleaning phase,
    a new user entry was create if:
    1. A newly-created Truth was linked to an author whose user entry did not yet exist;
    2. A follow edge referenced a user whose entry did not yet exist.

    Care was taken to indicate missing information in these entries. Specifically, these user entries contain a -1 in the following fields:
    timestamp, follower_count, following_count, finished_follower_scrape, finished_following_scrape, finished_truth_scrape

- When a user is scraped, the user entry's time_scraped is updated; if that user is seen again in the user queue, it will be scraped again if the time_scraped field is at least 7 days from the current date.
