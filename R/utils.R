
transform_args <- function(args) {
    if (length(args) == 0) {
        return(NULL)
    } else {
        args <- lapply(1:length(args), function(x) {
            if (inherits(args[[x]], "Date") ||
                inherits(args[[x]], "POSIXct")) {
                args[[x]] <- format(args[[x]], "%Y-%m-%dT%H:%M:%S")
            }
            paste0(names(args)[x], "=", paste0(args[[x]], collapse = ","),
                   collapse = "=")
        })
        paste0(args, collapse = "&")
    }
}

make_request <- function(apiurl) {
    apikey <- .get_api_key()
    if (is.null(apikey))
        stop(cat(crayon::red(cli::symbol$cross,
                             "A valid API key is needed for this request. ",
                             "Please call setup() with your API-token first.\n")))

    h <- new_handle()
    handle_setheaders(h, "Accepts" = "application/json",
                      "X-CMC_PRO_API_KEY" = apikey)
    curl_fetch_memory(apiurl, handle = h)
}

check_response <- function(req) {
    if (req$status_code != 200) {
        stop(cat(crayon::red(cli::symbol$cross,
                             "The request was not succesfull! \n",
                             "Request URL:\n", req$url, "\n",
                             "Response Content:\n",
                             jsonlite::prettify(rawToChar(req$content)),"\n")))
    }
}

modify_result <- function(content, case = 1) {

    if (case == 1) {
        l <- fromJSON(rawToChar(content), flatten = T)$data
        d <- data.frame(l)
    }
    # else if (case == 2) {
    #     l <- lapply(fromJSON(rawToChar(content), flatten = T)$data, as.data.frame)
    #     d <- data.table::rbindlist(l, fill = TRUE)
    # }
    else if (case == 3) {
        d <- fromJSON(rawToChar(content), flatten = T)$data
    }
    else {
        l <- fromJSON(rawToChar(content), flatten = T)$data
        l <- lapply(l, lapply, function(x) ifelse(is.null(x), NA, x))
        if (length(l) > 1) {
            d <- data.table::rbindlist(l)
        } else {
            d <- data.frame(l)
            ## Delete symbol from colum names
            colnames(d) <- gsub(paste0(d[1,3], "."), "",
                                colnames(d), fixed = T)
        }
    }
    setDT(d)
    colnames(d) <- gsub(".", "_", colnames(d), fixed = T)
    colnames(d) <- gsub("quote_", "", colnames(d), fixed = T)


    ## Convert timestamp columns
    colnams <- colnames(d)
    a <- c(grep("last_updated", colnams),
           grep("date_added", colnams),
           grep("first_historical_data", colnams),
           grep("last_historical_data", colnams),
           grep("timestamp", colnams))

    lapply(a, function(x) {
        d[[x]] <<- as.POSIXct(as.character(d[[x]]),
                             format = "%Y-%m-%dT%H:%M:%S.%OS")
    })

    return(d)
}

