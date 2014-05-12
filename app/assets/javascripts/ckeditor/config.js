if (typeof CKEDITOR === 'undefined') {
}else{

    CKEDITOR.stylesSet.add( 'my_styles',
        [
            {name: 'Раскрывающаяся фотография', element: 'img', attributes: {'class': 'fancybox_in_text'}},
            { name : 'Мой стиль' , element : 'span', attributes : { 'class' : 'my-style' } }
//            { name : 'Мой стиль' , element : 'div', attributes : { 'class' : 'my-style-2' } }
        ]);

    CKEDITOR.config.stylesSet = 'my_styles';

    CKEDITOR.config.contentsCss = ['/assets/application.css'];

    //CKEDITOR.config.bodyId = 'someid';
    //CKEDITOR.config.bodyClass = 'site-content';

    CKEDITOR.config.filebrowserBrowseUrl = '/ckeditor/attachment_files';

    CKEDITOR.config.filebrowserUploadUrl = '/ckeditor/attachment_files';

    CKEDITOR.config.filebrowserImageUploadUrl = '/ckeditor/pictures';

    CKEDITOR.config.filebrowserImageBrowseUrl = '/ckeditor/pictures';

}
