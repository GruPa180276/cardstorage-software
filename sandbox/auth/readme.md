# Authentication with Azure AD

## Overview

- <https://www.geeksforgeeks.org/difference-between-authentication-and-authorization/>
- <https://www.javatpoint.com/authentication-vs-authorization>
- maybe video at <https://learn.microsoft.com/en-us/azure/active-directory/develop/authentication-vs-authorization>

## Azure AD @ Litec.ac.at

Genral Approach decription: <https://medium.com/arfitect/azure-ad-authentication-in-flutter-5eded05335d1>

- An Tenant App was already created at the Linzer Technikum Azure AD side (called Cardstorage) by HASP
- recommended package: <https://pub.dev/packages/aad_oauth> 
  - for latest details and examples look at the according github page: <https://github.com/Earlybyte/aad_oauth>
- Possible alternative: <https://pub.dev/packages/azure_ad_authentication>


## Azure AD B2C [OPTIONAL!]

- I (hasp) would even say: Not recommended for this use case.
- You need Azure account (differs from Tenant Azure Ad account)
- To understand B2C: https://www.youtube.com/watch?v=M23P7tj_bXA&t=1518s
- Good overview: <https://medium.com/flutter-community/flutter-azure-authentication-with-ad-b2c-8b76c81dd48e>

## Secure Handling of IDs and Passworts (and settings)

> :warning: NEVER store client and tenant ID directly in the code (and push that to github)! BAD BAD BAD BOY! 

- Use some kind of local .env file where IDs are stored, and put that in .gitignore
  - Maybe that package is usable: <https://pub.dev/packages/flutter_dotenv>
- If you are going to use CI/CD (github actions) then have a look at github secrets to store the information. See
  - <https://docs.github.com/en/actions/security-guides/encrypted-secrets> 
  - <https://docs.github.com/en/rest/actions/secrets> 
  - if you use .env file - maye that action is worth a shot: <https://github.com/marketplace/actions/create-env-file>
