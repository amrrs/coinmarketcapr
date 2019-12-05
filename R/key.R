#' Returns API key details and usage stats. This endpoint can be used to programmatically monitor your key
#' usage compared to the rate limit and daily/monthly credit limits available to your API plan.
#' You may use the Developer Portal's account dashboard as an alternative to this endpoint.
#' @title Get API-Key Info
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#tag/key}{API documentation}
#' @family Key
#' @return A dataframe with all API key infos
#' @examples \dontrun{
#' get_api_info()
#' }
#' @export
get_api_info <- function() {
        apikey <- .get_api_key()
        if (is.null(apikey) || apikey == "") {
                stop(cat(crayon::red(cli::symbol$cross,
                                     "No API key found. Please call setup() with your API key first.\n")))
        }

        base_url <- .get_baseurl()

        ## Build Request (new API) ##########
        what <- paste0("key/info")
        apiurl <- sprintf("https://%s/v1/%s", base_url, what)

        ## Make Request ##########
        req <- make_request(apiurl)

        ## Check Response ##########
        check_response(req)

        ## Modify Result ##########
        modify_result(req$content)
}
