# HOW TO RUN 
1.ドメインとアクセストークンの設定   
`~/access_token` に
```
DOMAIN='YOURDOMAIN'
ACCESS_TOKEN='YOURTOKEN'
```
を作成.  

2. Mastodonのアップデート先のバージョン指定  
```
git fetch 
git checkout VERSION
```  

3. Run the script  
```
./mastodon-update-script.sh
```
