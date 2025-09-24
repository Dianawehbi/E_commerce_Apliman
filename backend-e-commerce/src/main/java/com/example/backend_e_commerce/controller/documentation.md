================
# Customers APIS 
================

  **GET** `/customers`
  **Get** : `'/customers/search?name=..&page=1$size=10'`
    - Return : 
    {
      "content": [
        {
          "id": 1,
          "username": "diana",
          "email": "diana@gmail.com",
          "phone": "8233",
          "address": "bhwbc",
          "invoiceIds": [10, 11]
        }, ..
      ]
        "pageable": {
        "pageNumber": 0, "pageSize": 20,
      },
      "totalPages": 1, "size": 20,
    }


  **POST** : `"/customers"`
  **GET** : `'/customers/:id'` (without body)
  **PUT** : `'customers/:id'`
    - body: {
        "username": "samiha",
        "email": "samiha@gmail.com",
        "phone": "8233",
        "address": "bhwbc"
    }
    -  Return : 
    {
        "id": 10,
        "username": "samiha",
        "email": "samihka@gmail.com",
        "phone": "8233",
        "address": "bhwbc",
        "invoiceIds": []
    }

  **DELETE** : `'customers/:id`


============
# Items APIS 
============

  **DELETE** : `'items/:id`

  **GET** `/items`
  **Get** : `'/items/search?name=..&page=1$size=10'`
  - Return : 
      {
    "content": [
        {
            "id": 5,
            "itemName": "hair perfume",
            "description": "Alvin dor serum ",
            "image_path": null,
            "price": 4.0,
            "stockQuantity": 7,
            "categoryId": 3
        },
        ]
          "pageable": {
          "pageNumber": 0, "pageSize": 20,
        },
        "totalPages": 1, "size": 20,
      }


  **POST** : `"/items"`
  **GET** : `'/items/:id'` (without body)
  **PUT** : `'items/:id'`
   - body: {
      "itemName": "fondation",
      "description": "hdc",
      "price": 12.0,
      "stockQuantity": 12
    }
   - Return : 
      {
          "id": 19,
          "itemName": "fondation",
          "description": "hdc",
          "image_path": null,
          "price": 12.0,
          "stockQuantity": 12,
          "categoryId": null
      }


==============
# Invoice APIS 
==============

  **DELETE** : `'invoices/:id`

  **GET** `/invoices`
  **Get** : `'/invoices/customer_id/:id`
  **Get** : `'/invoices/customer_name/:customer_name`
  **Get** : `'/invoices/:id`
  - Return : 
      {
    "content": [
        {
            "id": 10,
            "customerId": 1,
            "totalAmount": 12.0,
            "invoiceDate": "2025-09-18T06:07:15Z",
            "invoiceitems": [
                {
                    "id": 8,
                    "itemId": 5,
                    "invoiceId": 10,
                    "unitPrice": 4.0,
                    "quantity": 0
                },
                {
                    "id": 9, ..........
                }
            ]
        },....
        ]
          "pageable": {
          "pageNumber": 0, "pageSize": 20,
        },
        "totalPages": 1, "size": 20,
      }


  **POST** : `"/invoices"`
  **GET** : `'/invoices/:id'` (without body)
  **PUT** : `'invoices/:id'` - while updating the invoice you should add inside invoiceitems all items(even you dont want to upate them)
                            -  to do not loose them 
   - body:
      {
        "customerId": 1,
        "invoiceitems": [
            {
                "itemId": 1,
                "unitPrice": 2,
                "quantity": 3
            },
            {
                "itemId": 2,
                "unitPrice": 1,
                "quantity": 1
            }
        ]
    }
   - Return : 
      {
        "id": 13,
        "customerId": 1,
        "totalAmount": 40.0,
        "invoiceDate": "2025-09-23T13:17:08.902671Z",
        "invoiceitems": [
            {
                "id": 13,
                "itemId": 10,
                "invoiceId": 13,
                "unitPrice": 12.0,
                "quantity": 3
            },
            {
                "id": 14,
                "itemId": 5,
                "invoiceId": 13,
                "unitPrice": 4.0,
                "quantity": 1
            }
        ]
    }


