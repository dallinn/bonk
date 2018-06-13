<!DOCTYPE html>
<html lang="en">
<head>
    @include('partials._head', [ 'title' => 'Dev Test Add' ])
</head>

<body>

@include('partials._nav')

<div class="container">
    @yield('content')
    <form id="postForm" action="/addPost" method="post">
        <input type="hidden" name="_token" value="{{ csrf_token() }}">
        <div class="form-group">
            <input placeholder="Enter title here" type="text" id="title" name="title" class="form-control" required />
        </div>
        <div class="form-group">
            <textarea name="body" id="body" class="form-control" required></textarea>
        </div>
        <input type="submit" class="btn btn-default" value="Submit" />
    </form>
    @include('partials._footer')

</div> <!-- end of .container -->

@include('partials._javascript')
<script type="application/javascript">
$(document).ready(function(){
    $('#postForm').on('submit', function(e){
        e.preventDefault();
        var title = $('#title').val();
        var body = $('#title').val();
        if (title.length < 5 || body.length < 5) {
            alert('Title and Body require at least 5 characters');
        } else {
            this.submit();
        }
    });
});
</script>

@yield('scripts')

</body>
</html>
