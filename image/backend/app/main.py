#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@author: tom@itri.org.tw 
"""
import logging
import os
import signal

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import ORJSONResponse

# from starlette.middleware.base import BaseHTTPMiddleware

# from .core.config import settings
# from .core.exception_handlers import internal_server_error_handler
# from .core.middlewares import add_process_time_header
# from .core.routers import (
#     admin_router,
#     auth_router,
#     check_router,
#     feedback_router,
#     report_router,
#     verify_router,
#     user_router,
#     third_party_router,
#     student_router,
#     jointdefense_router,
#     contractshopalert_router,
#     llm_router,
# )
# from .version import VERSION

# 使用 ORJSONResponse 取代 JSONResponse，可加速處理時間
# Ref: https://fastapi.tiangolo.com/advanced/custom-response/?h=orjson#use-orjsonresponse
app = FastAPI(
    default_response_class=ORJSONResponse,
    # docs_url=settings.DOCS_URL,  # 可透過設定檔改變網址或disable.
    redoc_url=None,  # 不使用redoc風格的API doc.
    # openapi_url=settings.OPENAPI_URL
)

# # 當遇到Exception時的回傳內容可在這裡設定.
# app.add_exception_handler(Exception, internal_server_error_handler)

# # add `add_process_time_header` middleware, 用於在請求回傳之header增加處理時間.
# # Ref: https://fastapi.tiangolo.com/tutorial/middleware/#create-a-middleware
# # 若想加快這部分的運行時間，可自行改為 `TimingMiddleware`.
# # Ref: https://github.com/steinnes/timing-asgi
# #      https://github.com/tiangolo/fastapi/issues/2241
# app.add_middleware(BaseHTTPMiddleware, dispatch=add_process_time_header)
# # add `db_session_middleware` middleware, 用於處理API之db session(create/rollback/close).
# # Ref: https://fastapi.tiangolo.com/tutorial/sql-databases/#alternative-db-session-with-middleware
# # app.add_middleware(BaseHTTPMiddleware, dispatch=db_session_middleware)


# # Set all CORS enabled origins.
# if settings.BACKEND_CORS_ORIGINS or settings.BACKEND_CORS_ORIGIN_REGEX:
#     app.add_middleware(
#         CORSMiddleware,
#         allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
#         allow_origin_regex=settings.BACKEND_CORS_ORIGIN_REGEX,
#         allow_credentials=True,
#         allow_methods=["*"],
#         allow_headers=["*"],
#     )

# # auth_router 類似 flask 的 Blueprints
# # 注意：auth_routher的prefix若有修改時,
# #      應同步修改: OAuth2PasswordBearer(tokenUrl=...)
# app.include_router(auth_router.router, prefix="/v1/auth")
# # app.include_router(check_router.router, prefix="/v1/check")
# # app.include_router(report_router.router, prefix="/v1/report")
# # app.include_router(verify_router.router, prefix="/v1/verify")
# # app.include_router(feedback_router.router, prefix="/v1/feedback")
# # 管理人員專用的API, 不對外開放.
# app.include_router(admin_router.router, prefix="/v1/admin")
# # app.include_router(third_party_router.router, prefix="/v1/third_party")
# # 一般人員使用的API, 供修改帳號資訊.
# app.include_router(user_router.router, prefix="/v1/user")

# # 聯合防禦業者相關 API
# app.include_router(jointdefense_router.router, prefix="/v1/jointdefense")
# # 特店警示相關 API
# app.include_router(contractshopalert_router.router, prefix="/v1/contractshop")

# # 學生資料API(v1.06) - kamitom測試用
# # app.include_router(student_router.router, prefix="/v1/student")

# # TODO: Add new router
# app.include_router(llm_router.router, prefix="/v1/llm")

@app.get("/", status_code=200, summary="回傳程式版本資訊，可用於確認伺服器活著.")
def root():
    """
    回傳程式版本資訊，可用於確認伺服器活著.
    """
    return {"msg": "server is ready.", "version": "1.2.3"}
    # return {"msg": "server is ready.", "version": VERSION}



@app.get("/reload", status_code=202)
def reload_worker():
    """
    建立新worker, 再關閉舊worker.
    可達成無downtime的資料更新.
    """

    # NOTE: 若PRELOAD=False, 則worker全部變數會完整重新載入
    # NOTE: 若PRELOAD=True, 則worker會繼續沿用之前preload好的變數
    # 所以資料不會更新，而若要更新這些變數則應修改於reload.py

    logging.info("call sighup to reload...")
    # 將SIGHUP傳送至gunicorn process(i.e. worker的parent process)
    os.kill(os.getppid(), signal.SIGHUP)
    return {"msg": "reloading"}
